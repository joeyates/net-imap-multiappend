# frozen_string_literal: true

RSpec.describe Net::IMAP do
  it "has a #multiappend method" do
    expect(subject).to respond_to(:multiappend)
  end
end
