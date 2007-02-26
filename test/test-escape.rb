require 'test/unit'
require 'escape'

class TestEscape < Test::Unit::TestCase
  def test_shell_command
    assert_equal("com arg", Escape.shell_command(%w[com arg]))
  end

  def test_html_text
    assert_equal('a&amp;&lt;&gt;"', Escape.html_text('a&<>"'))
  end

  def test_html_attr
    assert_equal('"a&amp;&lt;&gt;&quot;"', Escape.html_attr('a&<>"'))
  end
end

class TestEscapePercentEncoded < Test::Unit::TestCase
  def test_eq
    assert(Escape::PercentEncoded.new("foo") == Escape::PercentEncoded.new("foo"))
    assert(Escape::PercentEncoded.new("foo") != Escape::PercentEncoded.new("bar"))
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

  def assert_equal_pe(str, tst)
    assert_equal(Escape::PercentEncoded.new(str), tst)
  end

  def uri_segment
    assert_class(Escape::PercentEncoded, Escape.uri_segment("foo"))
    assert_equal_pe("a%2Fb", Escape.uri_segment("a/b"))
  end

  def uri_path
    assert_class(Escape::PercentEncoded, Escape.uri_path("foo"))
    assert_equal_pe("a/b/c", Escape.uri_path("a/b/c"))
    assert_equal_pe("a%3Fb/c%3Fd/e%3Ff", Escape.uri_path("a?b/c?d/e?f"))
  end

  def html_form
    assert_class(Escape::PercentEncoded, Escape.html_form([["foo","bar"]]))
    assert_equal_pe("a=b&c=d", Escape.html_form([["a","b"], ["c","d"]]))
    assert_equal_pe("a=b;c=d", Escape.html_form([["a","b"], ["c","d"]], ';'))
    assert_equal_pe("k=1&k=2", Escape.html_form([["k","1"], ["k","2"]]))
    assert_equal_pe("k%3D=%26%3B%3D", Escape.html_form([["k=","&;="]]))
  end

end
