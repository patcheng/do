share_examples_for 'supporting DateTime' do

  include DataObjectsSpecHelpers

  before :all do
    setup_test_environment
  end

  before :each do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after :each do
    @connection.close
  end

  describe 'reading a DateTime' do

    describe 'with manual typecasting' do

      before  do
        @command = @connection.create_command("SELECT release_date FROM widgets WHERE ad_description = ?")
        @command.set_types(DateTime)
        @reader = @command.execute_reader('Buy this product now!')
        @reader.next!
        @values = @reader.values
      end

      after do
        @reader.close
      end

      it 'should return the correctly typed result' do
        @values.first.should be_kind_of(DateTime)
      end

      it 'should return the correct result' do
        date = @values.first
        Date.civil(date.year, date.mon, date.day).should == Date.civil(2008, 2, 14)
      end

    end

  end

  describe 'writing an DateTime' do

    before  do
      @reader = @connection.create_command("SELECT id FROM widgets WHERE release_datetime = ?").execute_reader(DateTime.civil(2008, 2, 14, 00, 31, 12, Rational(1, 24)))
      @reader.next!
      @values = @reader.values
    end

    after do
      @reader.close
    end

    it 'should return the correct entry' do
      @values.first.should == 1
    end
    
  end

end

share_examples_for 'supporting DateTime autocasting' do

  include DataObjectsSpecHelpers

  before :all do
    setup_test_environment
  end

  before :each do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after :each do
    @connection.close
  end

  describe 'reading a DateTime' do

    describe 'with automatic typecasting' do

      before  do
        @reader = @connection.create_command("SELECT release_datetime FROM widgets WHERE ad_description = ?").execute_reader('Buy this product now!')
        @reader.next!
        @values = @reader.values
      end

      after do
        @reader.close
      end

      it 'should return the correctly typed result' do
        @values.first.should be_kind_of(DateTime)
      end

      it 'should return the correct result' do
        @values.first.should == Time.local(2008, 2, 14, 00, 31, 12).to_datetime
      end

    end

  end

end