class String
  def auto_correct!
    self.auto_space!

    dicts = AutoCorrect::DICTS.merge Settings.dicts

    self.gsub! /([\d\p{Han}：:]|\s|^)([a-zA-Z\d\-\_\.]+)([\d\p{Han},，。；]|\s|$)/u do
      key = "#$2".downcase
      if dicts.has_key?(key)
        ["#$1", dicts[key], "#$3"].join("")
      else
        "#$1#$2#$3"
      end
    end

    self
  end
end