# frozen_string_literal: true

RSpec.describe ObsHtmlSanitizer::MarkdownRender do
  let(:markdown_render) { described_class.new }

  it { expect(markdown_render).to_not be_nil }

  describe "#block_code" do
    let(:ruby_code) { "puts 3 + 3" }
    let(:ruby_coderay_code) do
      <<~RUBY_CODE
        <div class="CodeRay">
          <div class="code"><pre>puts <span class="integer">3</span> + <span class="integer">3</span></pre></div>
        </div>
      RUBY_CODE
    end
    let(:plaintext) { "Hello World" }

    let(:plaintext_coderay_code) do
      <<~PLAINTEXT_CODE
        <div class="CodeRay">
          <div class="code"><pre>Hello World</pre></div>
        </div>
      PLAINTEXT_CODE
    end

    it { expect(markdown_render.block_code(ruby_code, :ruby)).to eq(ruby_coderay_code) }
    it { expect(markdown_render.block_code(plaintext, :plaintext)).to eq(plaintext_coderay_code) }
  end

  describe "#block_html" do
    it { expect(markdown_render.block_html("<b>foo</foo>")).to eq("<b>foo</b>") }
    it { expect(markdown_render.block_html("<a href='/foo'>foo</a>")).to eq("foo") }
    it { expect(markdown_render.block_html("<script>javascript:alert(1);</script>")).to eq("javascript:alert(1);") }
    it {
      expect(markdown_render.block_html("<script\x20type=\"text/javascript\">javascript:alert(1);</script>")).to eq("javascript:alert(1);")
    }
  end

  describe "#link" do
    let(:base_url) { "http://localhost:3000" }

    it { expect(markdown_render.link(nil, nil, nil)).to be_nil }

    context "without base_url" do
      it { expect(markdown_render.link("/foo", "Foo", "Click Foo")).to eq("<a href='/foo' title='Foo'>Click Foo</a>") }
    end

    context "with base_url" do
      it {
        expect(markdown_render.link("/foo", "Foo", "Click Foo",
                                    base_url)).to eq("<a href='#{base_url}/foo' title='Foo'>Click Foo</a>")
      }
    end

    context "wrong base_url" do
      let(:base_url) { "http:%localhost:AAAA" }

      it {
        expect do
          markdown_render.link("/foo", "Foo", "Click Foo",
                               base_url)
        end.to raise_error(URI::InvalidURIError)
      }
    end
  end
end
