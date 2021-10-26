# frozen_string_literal: true
require 'rails/html/scrubbers'

module ObsHtmlSanitizer
  class MarkdownRender < Redcarpet::Render::Safe
    def block_html(raw_html)
      # sanitize the HTML we get
      scrubber = Rails::Html::PermitScrubber.new.tap { |a| a.tags = %w[b em i strong u pre] }
      Rails::Html::SafeListSanitizer.new.sanitize(raw_html, scrubber: scrubber)
    end

    # unfortunately we can't call super (into C) - see vmg/redcarpet#51
    def link(link, title, content, base_url = "")
      # A return value of nil will not output any data
      # the contents of the span will be copied verbatim
      return nil if link.blank?

      title = " title='#{title}'" if title.present?
      link = URI.join(base_url, link) if base_url.present?
      "<a href='#{link}'#{title}>#{CGI.escape_html(content)}</a>"
    end

    def block_code(code, language)
      language ||= :plaintext
      CodeRay.scan(code, language).div(css: :class)
    rescue ArgumentError
      CodeRay.scan(code, :plaintext).div(css: :class) unless language == :plaintext
    end
  end
end
