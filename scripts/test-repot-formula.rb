require "minitest/autorun"
require_relative "repot-formula"

class RepotFormulaTest < Minitest::Test
  def setup
    @names = RepotFormula::TARGETS.map { |target| "repot-0.2.0-#{target}.tar.gz" }
    @release = { "tag_name" => "v0.2.0", "draft" => false, "prerelease" => false,
                 "assets" => (@names + ["SHA256SUMS"]).map { |name| { "name" => name } } }
    @manifest = @names.each_with_index.map { |name, index| "#{index.to_s * 64}  #{name}\n" }.join
  end

  def test_complete_release_binds_each_url_to_its_own_checksum
    formula = RepotFormula.render(@release, @manifest)
    assert_includes formula, 'version "0.2.0"'
    @names.each_with_index do |name, index|
      assert_match(%r{/v0\.2\.0/#{Regexp.escape(name)}"\n\s+sha256 "#{index.to_s * 64}"}, formula)
    end
    assert_equal 4, formula.scan('sha256 "').size
  end

  def test_legacy_formula_checksum_is_ignored
    manifest = @manifest + "#{'f' * 64}  repot.rb\n"
    assert_equal RepotFormula.render(@release, @manifest), RepotFormula.render(@release, manifest)
  end

  def test_rejects_incomplete_or_malformed_checksums
    ["", @manifest.lines.drop(1).join, @manifest + @manifest.lines.first,
     @manifest.sub("0" * 64, "invalid")].each do |manifest|
      assert_raises(RuntimeError) { RepotFormula.render(@release, manifest) }
    end
  end

  def test_rejects_missing_assets_and_unpublished_versions
    [@release.merge("draft" => true), @release.merge("prerelease" => true),
     @release.merge("tag_name" => "v1.0.0; bad"), @release.merge("assets" => [])].each do |release|
      assert_raises(RuntimeError) { RepotFormula.render(release, @manifest) }
    end
  end
end
