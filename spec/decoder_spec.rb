require "king_konf"

describe KingKonf::Decoder do
  describe ".boolean" do
    it "decodes `true`, `false`, `1`, and `0`" do
      expect(KingKonf::Decoder.boolean("true")).to eq true
      expect(KingKonf::Decoder.boolean("1")).to eq true
      expect(KingKonf::Decoder.boolean("false")).to eq false
      expect(KingKonf::Decoder.boolean("0")).to eq false
    end

    it "raises ConfigError on other values" do
      expect {
        KingKonf::Decoder.boolean("hello")
      }.to raise_exception(KingKonf::ConfigError, '"hello" is not a boolean: must be one of true, 1, false, 0')
    end
  end

  describe ".float" do
    it "decodes floats" do
      expect(KingKonf::Decoder.float("1.5")).to eq 1.5
    end
  end

  describe ".symbol" do
    it 'decodes string as symbol' do
      expect(KingKonf::Decoder.symbol("string")).to eq :string
    end
  end

  describe ".duration" do
    it "decodes plain integers as seconds" do
      expect(KingKonf::Decoder.duration("100")).to eq 100
    end

    it "decodes floats as fractional seconds" do
      expect(KingKonf::Decoder.duration("5.5")).to eq 5.5
      expect(KingKonf::Decoder.duration(".9")).to eq 0.9
    end

    it "decodes the empty string as nil" do
      expect(KingKonf::Decoder.duration("")).to eq nil
    end

    it "decodes shorthand duration format" do
      duration = [
        1 * 60 * 60 * 24 * 7,
        2 * 60 * 60 * 24,
        1 * 60 * 60,
        30 * 60,
        10,
        0.5,
      ].sum

      expect(KingKonf::Decoder.duration("1w 2d 1h 30m 10s 500ms")).to eq duration
      expect(KingKonf::Decoder.duration("1w2d1h30m10s500ms")).to eq duration
    end

    it "raises ConfigError on invalid input" do
      expect {
        KingKonf::Decoder.duration("hello")
      }.to raise_exception(KingKonf::ConfigError, '"hello" is not a duration: must be e.g. `1h 30m`')
    end
  end
end
