require "spec_helper"

module MiqAeServiceTenantSpec
  describe MiqAeMethodService::MiqAeServiceTenant do
    let(:settings) { {} }
    let(:tenant) { FactoryGirl.create(:tenant, :name => 'fred', :domain => 'a.b', :parent => root_tenant, :description => "Krueger") }


    let(:root_tenant) do
      MiqRegion.seed
      Tenant.seed
      Tenant.root_tenant
    end

    let(:service_tenant) { MiqAeMethodService::MiqAeServiceTenant.find(tenant.id) }

    before do
      stub_server_configuration(settings)
    end

    it "#name" do
      expect(service_tenant.name).to eq('fred')
    end

    it "#domain" do
      expect(service_tenant.domain).to eq('a.b')
    end

    it "#description" do
      expect(service_tenant.description).to eq('Krueger')
    end

    it "#tenant_quotas" do
      cpu_quota = TenantQuota.create(:name => "cpu_allocated", :unit => "int", :value => 2, :tenant_id => tenant.id)
      storage_quota = TenantQuota.create(:name => "storage_allocated", :unit => "GB", :value => 160, :tenant_id => tenant.id)
      ids = [cpu_quota.id, storage_quota.id]
      expect(service_tenant.tenant_quotas.collect(&:id)).to match_array(ids)
    end
  end
end
