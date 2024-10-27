class TestsController < Simpler::Controller

  def index
    @time = Time.now
    @tests = Test.all
    # status 201
    # headers['Content-Type'] = 'text/plain'
    # render plain: "Time: #{@time}"
    # puts headers
  end

  def show
    @test = Test.find(id: params[:id])
  end

  def create; end

end
