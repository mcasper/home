require 'open3'

def run(command)
  Open3.popen2(command, { err: [:child, :out] }) do |_stdin, output, wait_thread|
    output.each_line do |line|
      puts line
    end

    if !wait_thread.value.success?
      raise "Encountered error!"
    end
  end
end
