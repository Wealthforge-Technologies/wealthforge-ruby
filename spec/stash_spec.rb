require 'spec_helper'
require 'pp'


describe WealthForge::Stash do

  context 'stash' do

    before(:all) do
      @stash_id = ''

      WealthForge.configure do |config|
        config.environment = 'ci'
      end
    end



    it "create NEW stash" do

      stash_json = {
        data: {
          attributes: {
            data: {
              data1: 'data1 value',
              data2: 'data2 value',
              inv: {
                fname: 'jkdasjdkas',
                lname: 'jdsakdhjsahdjashdjas',
              }
            }
          },
          type: 'stashes'
        }
      }

      response = WealthForge::Stash.create stash_json
      pp JSON.parse response.env.body
      expect(response.status).not_to be_between(400, 600)
      p (JSON.parse response.env.body)['data']['id']
      @stash_id << (JSON.parse response.env.body)['data']['id']
    end


    it "get created stash" do
      response = WealthForge::Stash.get @stash_id
      pp JSON.parse response.env.body
      expect(response.status).not_to be_between(400, 600)
    end


    it "replace created stash" do

      new_stash_json = {
        data: {
          attributes: {
            data: {
              data1: 'data1 value-edited',
              data2: 'data2 value2',
              inv: {
                fname: 'jkdasjdkas',
                mname: 'bbbbb',
                lname: 'jdsakdhjsahdjashdjas',
              }
            }
          },
          type: 'stashes'
        }
      }



      response = WealthForge::Stash.update @stash_id, new_stash_json
      pp JSON.parse response.env.body
      expect(response.status).not_to be_between(400, 600)
    end


    it "get updated stash" do
      response = WealthForge::Stash.get @stash_id
      pp JSON.parse response.env.body
      expect(response.status).not_to be_between(400, 600)
    end




  end


end