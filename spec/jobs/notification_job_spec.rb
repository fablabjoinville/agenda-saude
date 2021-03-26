require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.info 'this is an info' }

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with('info', 'this is an info')
      .on_queue('default')
  end
end
