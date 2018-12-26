class Exports::AccountsPayables < Exports::Base

  # == Constants ============================================================

  # == Attributes ===========================================================

  # == Class Methods ========================================================

  # == Instance Methods =====================================================


  def process
    conditions = eval(self.export.export_conditions).try(:with_indifferent_access)
    date_params = DashboardForm.new(conditions)

    report = Reports::AccountsPayableReport.new(
      date_params.from_time, # to
      date_params.to_time    # from
    )
    csv = report.total_owing_transactions.search(conditions[:q]).result.copy_to_string
    export_process(csv)
  end
end