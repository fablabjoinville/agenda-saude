require Rails.root.join('app', 'services', 'slack_notifier')

SlackNotifier.slack_webhook_url = ENV['SLACK_WEBHOOK_URL']
