class ApiVersion
  attr_reader :version, :default

  def initialize(version, default = false)
    @version = version
    @default = default
  end

  def matches?(request)
    check_headers(request.headers) || default
  end

  private

  def check_headers(headers)
    test_version = headers[:HTTP_TEST_VERSION]
    test_version && test_version.in?(%w[v1 v2])
  end
end