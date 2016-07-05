require "rails_helper"

describe RolePolicy do
  subject { described_class }

  let(:regular_user) { build_stubbed(:user) }
  let(:role) { build_stubbed(:role) }
  let(:site_admin) { build_stubbed(:user, admin: true) }

  permissions :index? do
    context "as a logged out user" do
      it "can view all roles" do
        expect(subject).to permit(nil, role)
      end
    end

    context "as a regular user" do
      it "can view all roles" do
        expect(subject).to permit(regular_user, role)
      end
    end

    context "as a site admin" do
      it "can view all roles" do
        expect(subject).to permit(site_admin, role)
      end
    end
  end

  permissions :create?, :update? do
    context "as a logged out user" do
      it "is not permitted to create/update roles" do
        expect(subject).to_not permit(nil, role)
      end
    end

    context "as a regular user" do
      it "is not permitted to create/update roles" do
        expect(subject).to_not permit(regular_user, role)
      end
    end

    context "as a site admin" do
      it "is permitted to create/update roles" do
        expect(subject).to permit(site_admin, role)
      end
    end
  end
end
