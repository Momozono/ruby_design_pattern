# initial code
# bad_example1
class Report
  def initialize
    @title = '月次報告'
    @text = ['順調', '最高の調子']
  end

  def output_report
    puts ('<html>')
    puts (' <head>')
    puts ("  <title>#{@title}</title>")
    puts (' </head>')
    puts (' <body>')
    @text.each do |text|
      puts ("  <p>#{text}</p>")
    end
    puts (' </body>')
    puts ('</html>')
  end
end

report = Report.new
report.output_report

#3.1 #bad_example2
#変化する部分としない部分が混ざっている

class Report
  def initialize
    @title = '月次報告'
    @text = ['順調', '最高の調子']
  end

  def output_report(format)
    if format == :plain
      puts ("***#{@title}***")
    elsif format == :html
      puts ('<html>')
      puts (' <head>')
      puts (" <title>#{@title}</title>")
      puts (' </head>')
      puts (' <body>')
    else
      raise "Unknown format: #{format}"
    end

    @text.each do |line|
      if format == :plain
        puts line
      else
        puts ("  <p>#{line}</p>")
      end
    end

    if format == :html
      puts (' </body>')
      puts ('</html>')
    end
  end
end

report = Report.new
report.output_report(:plain)



# 詳細はサブクラスに持たせる
# これはまだ本当の抽象クラスではない
class Report
  def initialize
    @title = '月次報告'
    @text = ['順調', '最高の調子']
  end

  def output_report
    output_start
    output_head
    output_body_start
    output_body
    output_body_end
    output_end
  end

  def output_body
    @text.each do |line|
      output_line(line)
    end
  end

  def output_start
    raise 'Called abstract method: output_start'
  end

  def output_head
    raise 'Called abstract method: output_head'
  end

  def output_body_start
    raise 'Called abstract method: output_body_start'
  end

  def output_line(line)
    raise 'Called abstract method: output_body'
  end

  def output_body_end
    raise 'Called abstract method: output_end'
  end

  def output_end
    raise 'Called abstract method: output_end'
  end
end

class HTMLReport < Report
  def output_start
    puts ('<html>')
  end

  def output_head
    puts ('<head>')
    puts ("<title>#{@title}</title>")
    puts ('</head>')
  end

  def output_body_start
    puts ('<body>')
  end

  def output_line(line)
    puts ("  <p>#{line}</p>")
  end

  def output_body_end
    puts ('</body>')
  end

  def output_end
    puts ('</html>')
  end
end

class PlainTextReport < Report
  def output_start
  end

  def output_head
    puts ("****#{@title}****")
  end

  def output_body_start
  end

  def output_line(line)
    puts (line)
  end

  def output_body_end
  end

  def output_end
  end
end

report = HTMLReport.new
report.output_report
report = PlainTextReport.new
report.output_report

# 抽象クラス内で抽象メソッドを定義。抽象メソッドが呼び出されると、
# その実際の処理は継承された具象サブクラスが実行する
# これでTemplateの切り替えができるようになる
# 抽象クラスは抽象的であり、変わらない処理を記述する
# 変わるものはサブクラスで定義
# 適切にメソッドをオーバーライドする
# 親抽象クラスの起爆メソッドだけはオーバーライドしない

# 3.4
class Report
  def initialize
    @title = '月次報告'
    @text = ['順調', '最高の調子']
  end

  def output_report
    output_start
    output_head
    output_body_start
    output_body
    output_body_end
    output_end
  end
  def output_body
    @text.each do |line|
      output_line(line)
    end
  end

  def output_start
  end

  def output_head
    raise 'Called abstract method: output_head'
  end

  def output_body_start
  end

  def output_line(line)
    raise 'Called abstract method: output_body'
  end

  def output_body_end
  end

  def output_end
  end
end


class PlainTextReport < Report
  def output_head
    puts "****#{@title}****"
  end

  def output_line(line)
    puts line
  end
end

class HTMLReport < Report
  def output_start
    puts ('<html>')
  end

  def output_head
    puts ('<head>')
    puts ("<title>#{@title}</title>")
    puts ('</head>')
  end

  def output_body_start
    puts ('<body>')
  end

  def output_line(line)
    puts ("  <p>#{line}</p>")
  end

  def output_body_end
    puts ('</body>')
  end

  def output_end
    puts ('</html>')
  end
end

h = HTMLReport.new
h.output_report

#フックメソッドにデフォルトの処理を書いておいてもいいし、それがないならエラーがおきるようにしておけばいい

class Report
  def initialize
    @title = '月次報告'
    @text = ['順調', '最高の調子']
  end
  
  def output_report
    puts('<html>')
    puts(' <head>')
    puts("<title>#{@title}</title>")
  end
end

class Report
  #############
  def output_report
    output_start
    output_title(@title)
    output_body_start
    for line in @text
      output_line(line)
    end
    output_body_end
    output_end
  end

  def output_start
    puts ('<html>')
  end

  def output_title(title)
    puts(' <head>')
    puts ("<title>#{@title}<title>")
    puts ('</head>')
  end
  #############
end

class Child < Report
end

#TemplateMethodに対する最適なアプローチは、徐々に適用すること



















































