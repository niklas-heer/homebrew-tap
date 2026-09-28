require "minitest/autorun"
require_relative "sideporch-formula"

class SideporchFormulaTest < Minitest::Test
  def setup
    @names = SideporchFormula::TARGETS.map { |target| "sideporch-0.1.0-#{target}.tar.gz" }
    @release = { "tag_name" => "v0.1.0", "draft" => false, "prerelease" => false,
                 "assets" => (@names + ["SHA256SUMS"]).map { |name| { "name" => name } } }
    @manifest = @names.each_with_index.map { |name, index| "#{index.to_s * 64}  #{name}\n" }.join
  end

  def test_complete_release_binds_each_url_to_its_own_checksum
    formula = SideporchFormula.render(@release, @manifest)
    refute_includes formula, "version \"", "Homebrew reads the version from the release URLs"
    @names.each_with_index do |name, index|
      assert_match(%r{/v0\.1\.0/#{Regexp.escape(name)}"\n\s+sha256 "#{index.to_s * 64}"}, formula)
    end
    assert_equal 4, formula.scan('sha256 "').size
    assert_includes formula, "unknown-linux-musl", "Linux uses the static musl builds"
  end

  def test_rejects_incomplete_or_malformed_checksums
    ["", @manifest.lines.drop(1).join, @manifest + @manifest.lines.first,
     @manifest.sub("0" * 64, "invalid"), @manifest + "#{'f' * 64}  extra.tar.gz\n"].each do |manifest|
      assert_raises(RuntimeError) { SideporchFormula.render(@release, manifest) }
    end
  end

  def test_rejects_missing_assets_and_unpublished_versions
    [@release.merge("draft" => true), @release.merge("prerelease" => true),
     @release.merge("tag_name" => "v1.0.0; bad"), @release.merge("assets" => [])].each do |release|
      assert_raises(RuntimeError) { SideporchFormula.render(release, @manifest) }
    end
  end
end
