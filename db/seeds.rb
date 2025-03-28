# The following four lines may spit out "Index does not
# exist" errors, but they don't matter.
Notice.__elasticsearch__.delete_index! force: true
Notice.__elasticsearch__.create_index! force: true

Entity.__elasticsearch__.delete_index! force: true
Entity.__elasticsearch__.create_index! force: true

# Execute seeds in a logical order
seed_files = %w[
  topics.rb
  relevant_questions.rb
  risk_triggers.rb
]

seed_files.each { |file| load("db/seeds/#{file}") }

class FakeNotice
  attr_reader :title, :source, :subject, :date_sent, :date_received,
              :body, :body_original, :review_required, :language

  def initialize
    @title = [
      'Lion King', 'Batman', 'Revenge of the Nerds', 'Harry Potter',
      'Star Wars', 'That Movie', 'Some Book', 'This Thing', 'I Give Up'
    ].sample

    @source = ['Online form', 'Email', 'Phone'].sample
    @subject = "Websearch Infringement Notification via #{@source}"
    @date_sent = (0..100).to_a.sample.days.ago
    @date_received = (0..100).to_a.sample.days.ago

    if rand(100) < 15
      @body = "Some #{Lumen::REDACTION_MASK} text"
      @body_original = 'Some sensitive text'
      @review_required = true
    else
      @review_required = false
    end

    @language = if rand(100) < 85
                  'en'
                else
                  Language.codes.sample
                end
  end

  def topics
    lim = (3..5).to_a.sample

    Topic.order('random()').limit(lim)
  end

  def tags
    (1..5).to_a.sample.times.map do
      %w[movie disney youtube sharknado snakes planes].sample
    end.uniq
  end

  def regulations
    (1..5).to_a.sample.times.map do
      [
        '46 C.F.R. § 294',
        '21 C.F.R. § 24',
        '1337 C.F.R. § 255',
        '1 C.F.R. § 3',
        '5 C.F.R. § 7'
      ].sample
    end.uniq
  end

  def jurisdictions
    (1..2).to_a.sample.times.map do
      %w[US CA MX GB FI JP].sample
    end.uniq
  end

  def kind
    %w[movie book video].sample
  end

  def work_description
    "#{title} #{kind}".titleize
  end

  def infringing_urls
    n = (5..100).to_a.sample

    n.times.map do |i|
      { url: "http://example.com/bad/url_#{i}" }
    end
  end

  def copyrighted_urls
    n = (1..3).to_a.sample

    n.times.map do |i|
      { url: "http://example.com/original_work/url_#{i}" }
    end
  end

  def recipient
    @recipient ||= [
      {
        kind: 'organization',
        name: 'Google',
        address_line_1: '1600 Amphitheatre Parkway',
        city: 'Mountain View',
        state: 'CA',
        zip: '94043',
        country_code: 'US'
      },
      {
        kind: 'organization',
        name: 'Twitter, Inc.',
        address_line_1: '100 Maple Leaf Rd.',
        city: 'Quebec',
        state: 'ON',
        zip: 'FFF 222',
        country_code: 'CA'
      }
    ].sample
  end

  def sender
    @sender ||= individuals.sample
  end

  def principal
    @principal ||= rand(100) < 30 ? sender : individuals.sample
  end

  def submitter
    @submitter ||= rand(100) < 60 ? sender : recipient
  end

  private

  def individuals
    [
      {
        name: 'Joe Lawyer',
        kind: 'individual',
        address_line_1: '1234 Anystreet St.',
        city: 'Anytown',
        state: 'CA',
        zip: '94044',
        country_code: 'US'
      },
      {
        name: 'Bill Somebody',
        kind: 'individual',
        address_line_1: '123 Any St.',
        city: 'Town',
        state: 'ON',
        zip: 'FFF 123',
        country_code: 'CA'
      },
      {
        name: 'Steve Simpson',
        kind: 'individual',
        address_line_1: '23 My St.',
        city: 'Scranton',
        state: 'CA',
        zip: '94044',
        country_code: 'US'
      },
      {
        name: 'Mike Itten',
        kind: 'individual',
        address_line_1: '12 Main St.',
        city: 'Springfield',
        state: 'CA',
        zip: '94044',
        country_code: 'US'
      }
    ]
  end
end

unless ENV['SKIP_FAKE_DATA']
  # Necessary to ensure we can see all the notice subclasses
  Chill::Application.eager_load!

  # count = (ENV['NOTICE_COUNT'] || '500').to_i

  # print "\n--> Generating #{count} Fake Notices"
  Ban.create!({
    body: 'From Bluesky (moderation@blueskyweb.xyz) on Sunday, 24 November 2024 at 18:09:

A Bluesky account you control (@virped.org) posted content that supports pedophilia or the sexual exploitation of minors, which is in violation of our Community Guidelines. As a responsible service, we cannot condone any behavior that compromises the safety or violates the rights of minors. As a result of these violations, we have taken down your account. We trust that you will understand the necessity of these measures and the gravity of the situation. You cannot use Bluesky to break the law or cause harm to others.
--

From Virpeds (hey@virped.org) on 24 November 2024 at 18:09:

We wish to appeal this decision. We are an organisation that is clearly and explicitly opposed to child sexual abuse and we discuss pedophilia only in this context and in this way. We do not promote pedophilia as an identity, but draw attention to the plight of those who develop this attraction. We have been established for over 10 years doing this work and are endorsed by scientists, survivors of childhood sexual abuse and others https://virped.org/oursupporters',
    entity_notice_roles_attributes: [
      {
        entity_attributes: {
          name: 'Virpeds'
        },
        name: 'recipient'
      },
      {
        entity_attributes: {
          name: 'Bluesky'
        },
        name: 'sender'
      }
    ],
    title: 'Ban action against Virpeds',
    works_attributes: [{}]
  })
  # for err in notice.errors
  #   puts err
  # end

  # count.times do
  #   fake = FakeNotice.new

  #   random_notice_class = Notice.subclasses.sample

  #   fake_attributes = {
  #     title: fake.title,
  #     subject: fake.subject,
  #     date_sent: fake.date_sent,
  #     date_received: fake.date_received,
  #     source: fake.source,
  #     topic_ids: fake.topics.map(&:id),
  #     tag_list: fake.tags,
  #     jurisdiction_list: fake.jurisdictions,
  #     body: fake.body,
  #     body_original: fake.body_original,
  #     review_required: fake.review_required,
  #     language: fake.language,
  #     works_attributes: [{
  #       description: fake.work_description,
  #       kind: fake.kind,
  #       infringing_urls_attributes: fake.infringing_urls,
  #       copyrighted_urls_attributes: fake.copyrighted_urls
  #     }],
  #     entity_notice_roles_attributes: [{
  #       name: 'recipient', entity_attributes: fake.recipient
  #     }, {
  #       name: 'sender', entity_attributes: fake.sender
  #     }, {
  #       name: 'principal', entity_attributes: fake.principal
  #     }, {
  #       name: 'submitter', entity_attributes: fake.submitter
  #     }]
  #   }

  #   if random_notice_class.respond_to?(:regulation_counts)
  #     fake_attributes.merge!(regulation_list: fake.regulations)
  #   end

  #   random_notice_class.create!(
  #     fake_attributes
  #   )

  #   print '.'
  # end
end
