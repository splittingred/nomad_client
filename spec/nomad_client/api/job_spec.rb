require 'spec_helper'
module NomadClient
  module Api
    RSpec.describe 'Job' do

      let!(:nomad_client) { NomadClient::Client.new('http://nomad.local') }

      describe 'job' do
        it 'should add the job method to the NomadClient::Client class' do
          expect(nomad_client).to respond_to :job
          expect(nomad_client.job).to be_kind_of NomadClient::Api::Job
        end
      end

      describe 'Job API methods' do
        let(:block_receiver) { double(:block_receiver) }
        let(:job_id)         { 'nomad-job' }
        let!(:connection)    { double(:connection) }

        before do
          allow(nomad_client).to receive(:connection).and_return(connection)
        end

        describe '#get' do
          it 'should call get with job_id' do
            expect(connection).to receive(:get).and_yield(block_receiver)
            expect(block_receiver).to receive(:url).with("job/#{job_id}/")

            nomad_client.job.get(job_id)
          end
        end

        describe '#create' do
          it 'should call post with job_id and a job json blob' do
            nomad_job = { "Job" => {} }
            expect(connection).to receive(:post).and_yield(block_receiver)
            expect(block_receiver).to receive(:url).with("job/#{job_id}")
            expect(block_receiver).to receive(:body=).with(nomad_job)

            nomad_client.job.create(job_id, nomad_job)
          end
        end
      end

    end
  end
end