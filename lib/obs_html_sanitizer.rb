# frozen_string_literal: true

require "uri"
require "cgi"
require "rails/all" # TODO: refine it to the necessary dependencies
require "redcarpet"
require "coderay"

require_relative "obs_html_sanitizer/version"
require_relative "obs_html_sanitizer/markdown_render"

module ObsHtmlSanitizer
  class Error < StandardError; end
end
