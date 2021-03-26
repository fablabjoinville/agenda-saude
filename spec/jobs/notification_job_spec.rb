require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.info 'this is an info' }

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with('info', 'this is an info')
      .on_queue('default')
  end

  it 'executes perform' do
    expect_any_instance_of(described_class).to receive(:send_message).with('ℹ️ this is an info')
    perform_enqueued_jobs { job }
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
