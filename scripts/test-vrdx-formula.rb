require "minitest/autorun"
require_relative "vrdx-formula"

class VrdxFormulaTest < Minitest::Test
  def setup
    @names = VrdxFormula::TARGETS.map { |target| "vrdx-v0.3.0-#{target}.tar.gz" }
    @release = { "tag_name" => "v0.3.0", "draft" => false, "prerelease" => false,
                 "assets" => (@names + ["SHA256SUMS"]).map { |name| { "name" => name } } }
    @manifest = @names.map { |name| "#{'a' * 64}  ./#{name}\n" }.join
  end

  def test_complete_release
    formula = VrdxFormula.render(@release, @manifest)
    assert_includes formula, 'version "0.3.0"'
    @names.each { |name| assert_includes formula, name }
    assert_equal 4, formula.scan('sha256 "').size
  end

  def test_rejects_incomplete_or_malformed_checksums
    ["", @manifest.lines.drop(1).join, @manifest + @manifest.lines.first,
     @manifest.sub('a' * 64, 'invalid')].each do |manifest|
      assert_raises(RuntimeError) { VrdxFormula.render(@release, manifest) }
    end
  end

  def test_rejects_missing_assets_and_unpublished_versions
    [@release.merge("draft" => true), @release.merge("prerelease" => true),
     @release.merge("tag_name" => 'v1.0.0; bad'), @release.merge("assets" => [])].each do |release|
      assert_raises(RuntimeError) { VrdxFormula.render(release, @manifest) }
    end
  end
end
