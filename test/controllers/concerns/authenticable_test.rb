class AuthenticableTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @authentication = MockController.new
  end

  test 'should get user from Authorization token' do
    @authentication.request.headers['Authorization'] = JsonWebToken.encode(user_id: @user.id)
    assert_equal @user.id, @authentication.current_user.id
  end

  test 'should not get user from empty Authorization token' do
    @authentication.request.headers['Authorization'] = nil
    assert_nil @authentication.current_user
  end

  class MockController
    attr_accessor :request

    def initialize
      mock_request = Struct.new(:headers)
      self.request = mock_request.new({})
    end

    def current_user
      return @current_user if @current_user

      header = request.headers['Authorization']
      return nil if header.nil?

      decoded = JsonWebToken.decode(header)
      @current_user = User.find(decoded[:user_id])
    end
  end
end
