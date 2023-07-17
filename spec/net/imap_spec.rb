# frozen_string_literal: true

RSpec.describe Net::IMAP do
  subject { described_class.new("localhost") }

  let(:socket) { instance_double(Socket, close: nil, gets: greeting, setsockopt: nil) }
  let(:greeting) do
    "* OK [CAPABILITY IMAP4rev1 ID ENABLE IDLE AUTH=PLAIN] MyIMAP ready.\r\n"
  end

  before do
    allow(Socket).to receive(:tcp) { socket }
  end

  it "has an added #multiappend method" do
    expect(subject).to respond_to(:multiappend)
  end

  it "has an added #can_multiappend? method" do
    expect(subject).to respond_to(:can_multiappend?)
  end

  describe "#multiappend" do
    let(:mailbox) { "mailbox" }
    let(:body1) { "body1" }
    let(:body2) { "body2" }
    let(:literal1) { instance_double(Net::IMAP::Literal, "literal1") }
    let(:literal2) { instance_double(Net::IMAP::Literal, "literal2") }
    let(:message1) { [body1] }
    let(:message2) { [body2] }

    before do
      allow(subject).to receive(:send_command)
      allow(subject).to receive(:multiappend).and_call_original
      allow(Net::IMAP::Literal).to receive(:new).with(body1) { literal1 }
      allow(Net::IMAP::Literal).to receive(:new).with(body2) { literal2 }
    end

    it "sends multiple messages" do
      subject.multiappend(mailbox, message1 + message2)

      expected = [literal1, literal2]
      expect(subject).
        to have_received(:send_command).
        with("APPEND", mailbox, *expected)
    end

    context "when the messages parameter is not an Array" do
      it "fails" do
        expect do
          subject.multiappend(mailbox, body1)
        end.to raise_error(TypeError)
      end
    end
  end

  describe "#can_multiappend?" do
    let(:capabilites) { %w(SASL-IR LITERAL+ MULTIAPPEND AUTH=PLAIN) }

    before do
      allow(subject).to receive(:capability) { capabilites }
    end

    context "when the IMAP server has LITERAL+ and MULTIAPPEND capabilities" do
      it "is true" do
        expect(subject.can_multiappend?).to be true
      end
    end

    context "when the IMAP server doesn't have LITERAL+ and MULTIAPPEND capabilities" do
      let(:capabilites) { %w(SASL-IR ID MULTIAPPEND AUTH=PLAIN) }

      it "is false" do
        expect(subject.can_multiappend?).to be false
      end
    end
  end
end
