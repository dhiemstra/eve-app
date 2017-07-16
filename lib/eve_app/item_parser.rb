module EveApp
  class ItemParser
    attr_reader :text, :lines, :header, :items

    def initialize(text)
      @text = text
      @lines = []

      normalized_lines
      determine_items
    end

    def header?
      !!header
    end

    def ships
      @_ships ||= items.select(&:ship?)
    end

    private

    def normalized_lines
      text.split(/\r?\n/).map(&:strip).map(&:presence).compact.each do |line|
        if Header.matches?(line)
          @header = Header.new(line)
        elsif line.include?(',')
          line.split(',').each do |sline|
            @lines.push(Line.new(sline))
          end
        else
          @lines.push(Line.new(line))
        end
      end
    end

    def determine_items
      @items = lines.select(&:valid?).group_by(&:type).map do |type, lines|
        OpenStruct.new(type: type, ship?: type.ship?, quantity: lines.map(&:quantity).sum)
      end
    end

    class Header
      REGEX = /\A\[(.+), (.+)\]\z/

      attr_reader :text, :type, :name

      def self.matches?(text)
        text =~ REGEX
      end

      def initialize(text)
        @text = text
        parse_header
      end

      private

      def parse_header
        data = text.scan(REGEX).first
        @type = EveApp::Type.find_by(name: data[0])
        @name = data[1]
      end
    end

    class Line
      REGEX = /(?<=\s|\t|^)(x?\s?[0-9]+\s?x?)(?=\s|\t|$)/i

      attr_reader :text, :parts, :type, :quantity, :quantity_words

      def initialize(text)
        @text = text
        @parts = text.split(/\t/)
        @quantity_words = find_quantity_words
        @type = EveApp::Type.where(name: search_strings).first
        @quantity = find_quantity if type
      end

      def valid?
        !!type
      end

      private

      def find_quantity_words
        matches = text.scan(REGEX)
        if matches.any?
          matches.flatten.compact.map(&:strip)
        else
          []
        end
      end

      def find_quantity
        return 0 unless type

        str = text
        str = parts[1] if parts.length > 2 && parts[1] =~ /[0-9]+/
        str = str.gsub(type.name, '')
        (str.strip.gsub(/[^0-9]/, '').presence || 1).to_i
      end

      def search_strings
        @_search_strings ||= [
          parts.first,
          text.split(',').first,
          quantity_words.map { |w| text.gsub(/\s#{w}\s?/, '') }
        ].flatten.compact.uniq
      end
    end
  end
end
