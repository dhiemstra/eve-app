require 'test_helper'

class EveApp::ItemParserTest < ActiveSupport::TestCase
  def parsed_items(input)
    parser = EveApp::ItemParser.new(input)
		parser.items.map { |i| [i.type.name, i.quantity] }
  end

  test "parse EFT header" do
    input = "[Garmur, Roaming Garmur]"
    parser = EveApp::ItemParser.new(input)

    assert parser.header?
    assert_equal 'Roaming Garmur', parser.header.name
    assert_equal types(:garmur).id, parser.header.type.try(:id)
  end

  test "parse an EFT text" do
		result = parsed_items(load_data_file('eft.txt'))
    expected = [
      ['Orthrus', 1], ['10MN Afterburner II', 10], ['100MN Afterburner I', 100], ['Warp Scrambler II', 5],
      ['Tracking Computer II', 1], ['800mm Repeating Cannon II', 3], ['Sensor Booster II', 2],
      ['Heavy Energy Neutralizer II', 300], ['Quake L', 1500], ['Tremor L', 1000], ['Barrage L', 2000],
      ['X-Large Ancillary Shield Booster', 1], ['Navy Cap Booster 400', 1]
    ]
    assert result & expected
  end

  test "parse EVE hangar text" do
		result = parsed_items(load_data_file('hangar.txt'))
    expected = [
      ['1200mm Artillery Cannon II', 14], ['Ballistic Control System II', 50], ['Coreli A-Type 5MN Microwarpdrive', 4],
      ['Nanite Repair Paste', 7000], ['Scimitar', 2], ['Small Core Defense Field Extender II', 25],
      ['Vexor', 1], ['Warp Disrupt Probe', 370]
    ]
    assert_equal result, expected
  end

	# test "ignores unmatched lines" do
	# 	# Unknown lala
	# 	# [Med slots]
	# end
  #
	# test "be able to parse copy & paste from hangar" do
	# 	# Mid-grade Slave Alpha	1	1.0
	# 	# Mid-grade Slave Beta	1	1.0
	# end
end
