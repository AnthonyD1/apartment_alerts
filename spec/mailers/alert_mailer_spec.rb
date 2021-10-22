require "rails_helper"

RSpec.describe AlertMailer do
  describe '#new_posts_email' do
    before do
      user = User.new(email: 'foo@example.com')
      @alert = build_stubbed(:alert, name: '2bd under $900')
      @new_posts = [CraigslistPost.new(title: 'Awesome deal', link: 'www.example.com')]
      @mailer = described_class.with(user: user,
                                    alert: @alert,
                                    new_posts: @new_posts).new_posts_email
    end

    context 'headers' do
      it 'renders the sender email' do
        expect(@mailer.from).to eq(['apartmentalertsupdates@gmail.com'])
      end

      it 'renders the receiver email' do
        expect(@mailer.to).to eq(['foo@example.com'])
      end

      it 'renders the subject' do
        expect(@mailer.subject).to eq('New Listings Found for 2bd under $900')
      end
    end

    context 'body' do
      it 'renders links' do
        alert_link = alert_url(@alert)
        new_post_link = @new_posts.first.link

        expect(@mailer.body.encoded).to include(alert_link)
        expect(@mailer.body.encoded).to include(new_post_link)
      end
    end
  end
end
