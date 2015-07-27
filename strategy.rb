# 一番最初の例　データの受け渡しが雑、クラスまるまる渡している。しかし、結合度はとても低い
class Formatter
  def output_report(title, text)
    raise 'Abstract method called'
  end
end

class HTMLFormatter < Formatter
  def output_report(title, text)
    puts ('<html>')
    puts ('<head>')
    puts ("<title>#{title}</title>")
    puts ('</head>')
    puts ('<body>')
    text.each do |line|
      puts ("<p>#{line}</p>")
    end
    puts ('</body>')
    puts ('</html>')
  end
end

class PlainTextFormatter < Formatter
  def output_report(title, text)
    puts ("*****#{title}*****")
    text.each do |line|
      puts line
    end
  end
end

class Report #　出力に関する要素を除去した データの設定と起動のみ
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(formatter)
    @title = '月次報告'
    @text = ['順調', '最高の調子']
    @formatter = formatter
  end

  def output_report
    @formatter.output_report(@title, @text)
  end
end

report = Report.new(HTMLFormatter.new)
report.output_report


# コンテキストとストラテジで必要な情報のみを共有する
class Report
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(formatter)
    @title = '月次報告'
    @text = ['順調', '最高の調子']
    @formatter = formatter
  end

  def output_report
    @formatter.output_report(self)
  end
end

class Formatter
  def output_report(context)
    raise 'Abstract method called'
  end
end

class HTMLFormatter < Formatter
  def output_report(context)
    puts ('<html>')
    puts ('<head>')
    puts ("<title>#{context.title}</title>")
    puts ('</head>')
    puts ('<body>')
    context.text.each do |line|
      puts ("<p>#{line}</p>")
    end
    puts ('</body>')
    puts ('</html>')
  end
end

hoge = Report.new
hoge.output_report




class Report
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(formatter)
    @title = '月次報告'
    @text = ['順調', '最高の調子']
    @formatter = formatter
  end

  def output_report
    @formatter.output_report(self) # このselfにはReportクラスのインスタンスが入る
  end
end

class HTMLFormatter
  def output_report(context) #contextにはReportクラスのインスタンスが入る
    puts ('<html>')
    puts ('  <head>')
    puts ("<title>#{context.title}</title>")
    context.text.each do |line|
      puts ("<p>#{line}</p>")
    end
    puts ('</body>')
    puts ('</html>')
  end
end

class PlainTextFormatter
  def output_report(context)
    puts ("*****#{context.title}*****")
    context.text.each do |line|
      puts line
    end
  end
end

p = Report.new(PlainTextFormatter.new) #HTMLFormatter.new
p.output_report


class Report
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(&formatter)
    @title = '月次報告'
    @text = ['順調', '最高の調子']
    @formatter = formatter
  end

  def output_report
    @formatter.call(self)
  end
end

HTML_FORMATTER = lambda do |context|
  puts ('<html>')
  puts (' <head>')
  puts ("  <title>#{context.title}</title>")
  puts (' </head>')
  puts ('<body>')
  context.text.each do |line|
    puts ("    <p>#{line}</p>")
  end
  puts ('</body>')
  puts ('</html>')
end

report = Report.new(&HTML_FORMATTER)
report.output_report

report = Report.new do |context|
  puts "#{context.title}"
  context.text.each do |line|
    puts line
  end
end

report.output_report