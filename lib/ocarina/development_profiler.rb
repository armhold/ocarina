require 'tmpdir'
require 'ruby-prof'

# simple tool for dumping performance stats, just like in Rails
#
# see: http://hiltmon.com/blog/2012/02/27/quick-and-dirty-rails-performance-profiling/
#
module Ocarina

  class DevelopmentProfiler

    def self.prof(file_name)

      RubyProf.start
      yield
      results = RubyProf.stop

      perf_dir = File.expand_path('../../../tmp/performance', __FILE__)
      FileUtils.mkdir_p perf_dir

      # Print a flat profile to text
      File.open "#{perf_dir}/#{file_name}-graph.html", 'w' do |file|
        RubyProf::GraphHtmlPrinter.new(results).print(file)
      end

      File.open "#{perf_dir}/#{file_name}-flat.txt", 'w' do |file|
        # RubyProf::FlatPrinter.new(results).print(file)
        RubyProf::FlatPrinterWithLineNumbers.new(results).print(file)
      end

      File.open "#{perf_dir}/#{file_name}-stack.html", 'w' do |file|
        RubyProf::CallStackPrinter.new(results).print(file)
      end

      puts "performance stats saved to: #{perf_dir}"
    end

  end

end
