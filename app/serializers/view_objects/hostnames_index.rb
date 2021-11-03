module ViewObjects
  class HostnamesIndex
    attr_accessor :hostname
    attr_accessor :count

    def initialize(hostname, count)
      @hostname = hostname
      @count = count
    end
  end
end
