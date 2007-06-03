require 'test/unit'
require 'escape'

class TestEscapeStringWrapper < Test::Unit::TestCase
  def test_eq
    assert(Escape::PercentEncoded.new("foo") == Escape::PercentEncoded.new("foo"))
    assert(Escape::PercentEncoded.new("foo") != Escape::PercentEncoded.new("bar"))
    assert(Escape::ShellEscaped.new("a") != Escape::PercentEncoded.new("a"))
  end

  def test_hash
    v1 = Escape::PercentEncoded.new("foo")
    v2 = Escape::PercentEncoded.new("foo")
    h = {}
    h[v1] = 1
    h[v2] = 2
    assert_equal(1, h.size)
    assert_equal(2, h[v1])
  end

  def test_new_dup
    s = "a"
    o = Escape::PercentEncoded.new(s)
    assert_not_equal(s.object_id, o.instance_variable_get(:@str).object_id)
    o = Escape::PercentEncoded.new_no_dup(s)
    assert_equal(s.object_id, o.instance_variable_get(:@str).object_id)
  end

  def test_escaped_string
    assert_equal("a", Escape::PercentEncoded.new("a").escaped_string)
  end
end

class TestEscapeShellEscaped < Test::Unit::TestCase
  def assert_equal_se(str, tst)
    assert_equal(Escape::ShellEscaped.new(str), tst)
  end

  def test_shell_command
    assert_equal_se("com arg", Escape.shell_command(%w[com arg]))
    assert_equal_se("ls /", Escape.shell_command(%w[ls /]))
    assert_equal_se("echo '*'", Escape.shell_command(%w[echo *]))
  end

  def test_shell_single_word
    assert_equal_se("''", Escape.shell_single_word(''))
    assert_equal_se("foo", Escape.shell_single_word('foo'))
    assert_equal_se("'*'", Escape.shell_single_word('*'))
  end

end

class TestEscapePercentEncoded < Test::Unit::TestCase
  def str_to_pe(obj)
    case obj
    when String
      Escape::PercentEncoded.new(obj)
    when Array
      obj.map {|e| str_to_pe(e) }
    else
      obj
    end
  end

  def assert_equal_pe(str, tst)
    assert_equal(str_to_pe(str), tst)
  end

  def test_percent_encoding
    assert_equal_pe(
      "%20%21%22%23%24%25%26%27%28%29%2A%2B%2C-.%2F"+
      "%3A%3B%3C%3D%3E%3F%40%5B%5C%5D%5E_%60%7B%7C%7D~",
      Escape.percent_encoding(' !"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'))
  end

  def test_uri_segment
    assert_equal_pe("a%2Fb", Escape.uri_segment("a/b"))
  end

  def test_uri_path
    assert_equal_pe("a/b/c", Escape.uri_path("a/b/c"))
    assert_equal_pe("a%3Fb/c%3Fd/e%3Ff", Escape.uri_path("a?b/c?d/e?f"))
  end

  def test_uri_path_ary
    assert_equal_pe("a/b/c", Escape.uri_path(%w[a b c]))
    assert_equal_pe("%2Fd/f", Escape.uri_path(%w[/d f]))
  end

  def test_html_form
    assert_kind_of(Escape::PercentEncoded, Escape.html_form([["foo","bar"]]))
    assert_equal_pe("a=b&c=d", Escape.html_form([["a","b"], ["c","d"]]))
    assert_equal_pe("a=b;c=d", Escape.html_form([["a","b"], ["c","d"]], ';'))
    assert_equal_pe("k=1&k=2", Escape.html_form([["k","1"], ["k","2"]]))
    assert_equal_pe("k%3D=%26%3B%3D", Escape.html_form([["k=","&;="]]))
  end

  def test_split_html_form
    assert_equal_pe([["a", "b"], ["c", "d"]], Escape::PercentEncoded.new("a=b&c=d").split_html_form)
    assert_equal_pe([["a", "b"], ["c", "d"]], Escape::PercentEncoded.new("a=b;c=d").split_html_form)
    assert_equal_pe([["k", "1"], ["k", "2"]], Escape::PercentEncoded.new("k=1&k=2").split_html_form)
    assert_equal_pe([["k%3D", "%26%3B%3D"]], Escape::PercentEncoded.new("k%3D=%26%3B%3D").split_html_form)
    assert_raise(Escape::InvalidHTMLForm) { Escape::PercentEncoded.new("a=b;cd").split_html_form }
    assert_raise(Escape::InvalidHTMLForm) { Escape::PercentEncoded.new("a=b;c=d;").split_html_form }
  end
end

class TestEscapeHTML < Test::Unit::TestCase
  def assert_equal_he(str, tst)
    assert_equal(Escape::HTMLEscaped.new(str), tst)
  end

  def assert_equal_hav(str, tst)
    assert_equal(Escape::HTMLAttrValue.new(str), tst)
  end

  def test_html_text
    assert_equal_he('a&amp;&lt;&gt;"', Escape.html_text('a&<>"'))
  end

  def test_html_attr_value
    assert_equal_hav('"a&amp;&lt;&gt;&quot;"', Escape.html_attr_value('a&<>"'))
  end
end

class TestEscapeMIME < Test::Unit::TestCase
  def assert_equal_mime(str, tst)
    assert_equal(Escape::MIMEParameter.new(str), tst)
  end

  def test_token
    assert_equal(true, Escape.mime_token?("abc"))
    assert_equal(false, Escape.mime_token?("a=b"))
  end

  def test_parameter_value
    assert_equal_mime('abc', Escape.mime_parameter_value("abc"))
    assert_equal_mime('"a/b/c"', Escape.mime_parameter_value("a/b/c"))
    assert_equal_mime('"\""', Escape.mime_parameter_value('"'))
    assert_raise(ArgumentError) { Escape.mime_parameter_value("\r") }
    assert_raise(ArgumentError) { Escape.mime_parameter_value("\n") }
    assert_raise(ArgumentError) { Escape.mime_parameter_value("\0") }
  end
end
