= escape - HTML/URI/shell escaping utilities

* http://www.a-k-r.org/escape/

== AUTHOR:

Tanaka Akira <akr@fsij.org>

== DESCRIPTION:

escape library provides several HTML/URI/shell escaping functions.

This library's shell escaping is more effective than that provided by the Ruby
standard library.

== FEATURES/PROBLEMS:

* several escaping/composing functions
  * HTML text
  * HTML attribute value
  * HTML form (x-www-form-urlencoded)
  * URI path
  * shell command line
* dedicated classes for escaped strings
* escape and compose strongly related strings at once

== DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

== FEATURES:

* several escaping/composing functions
  * HTML text
  * HTML attribute value
  * HTML form (x-www-form-urlencoded)
  * URI path
  * shell command line
* dedicated classes for escaped strings
* escape and compose strongly related strings at once

== SYNOPSIS:

  require 'rubygems'
  require 'escape'

  Escape.shell_command(["echo", "*"]) #=> #<Escape::ShellEscaped: echo '*'>
  Escape.uri_path("a?b/c?d/e?f") #=> #<Escape::PercentEncoded: a%3Fb/c%3Fd/e%3Ff>
  Escape.html_form([["a","b"], ["c","d"]]) #=> #<Escape::PercentEncoded: a=b&c=d>
  Escape.html_form({"a"=>"b", "c"=>"d"}) #=> #<Escape::PercentEncoded: a=b&c=d>
  Escape.html_text("a & b < c > d") #=> #<Escape::HTMLEscaped: a &amp; b &lt; c &gt; d>
  Escape.html_attr_value("ab&<>\"c") #=> #<Escape::HTMLAttrValue: "ab&amp;&lt;&gt;&quot;c">

== REQUIREMENTS:

* ruby : http://www.ruby-lang.org/

== DOWNLOAD:

* latest release: ((<escape-0.2.tar.gz|URL:escape-0.2.tar.gz>))

* development version on github:

    % git clone https://github.com/akr/escape

== INSTALL:

* rake install_gem

== DOCUMENTATION:

See rdoc/classes/Escape.html or
((<URL:http://www.a-k-r.org/escape/rdoc/classes/Escape.html>))

== DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

== LICENSE:

The modified BSD licence

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
  
   1. Redistributions of source code must retain the above copyright notice, this
      list of conditions and the following disclaimer.
   2. Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.
   3. The name of the author may not be used to endorse or promote products
      derived from this software without specific prior written permission.
  
  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
  OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
  IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
  OF SUCH DAMAGE.
