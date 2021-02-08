FROM opensuse/leap:15.2

WORKDIR "/obs_html_sanitizer"


RUN zypper -n in  gcc make libxml2-devel git ruby2.5 ruby2.5-devel ruby2.5-rubygem-bundler
