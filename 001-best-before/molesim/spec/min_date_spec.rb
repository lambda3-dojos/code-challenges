require './min_date'

describe "Min Date" do
	
	it { min_date("02/01/2012").should == Time.local(2012, 01, 02) }
	it { min_date("03/01/2012").should == Time.local(2012, 01, 03) }
	it { min_date("01/02/2012").should == Time.local(2012, 01, 02) }
	it { expect{ min_date("31/9/73")}.to raise_error(IllegalArgumentError) }
	it { min_date("31/12/12").should == Time.local(2012, 12, 31) }
	it { min_date("01/02/00").should == Time.local(2000, 01, 02) }
	it { min_date("01/02/0").should == Time.local(2000, 01, 02) }
	it { min_date("0/02/1").should == Time.local(2000, 01, 02) }
	it { min_date("1/2/00").should == Time.local(2000, 01, 02) }
	it { min_date("1/2/00").should == Time.local(2000, 01, 02) }
	it { min_date("1/2/10").should == Time.local(2001, 02, 10) }
	it { min_date("3/2/1").should == Time.local(2001, 02, 03) }
	it { min_date("3/1/2").should == Time.local(2001, 02, 03) }
	it { min_date("30/1/2").should == Time.local(2002, 1, 30) }
	it { expect { min_date("29/2/2100")}.to raise_error(IllegalArgumentError) }
	it { min_date("29/2/2012").should == Time.local(2012, 02, 29) }
	it { expect { min_date("31/11/2012")}.to raise_error(IllegalArgumentError) }

end