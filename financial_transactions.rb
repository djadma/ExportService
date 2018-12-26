class Exports::FinancialTransactions < Exports::Base

  # == Constants ============================================================

  # == Attributes ===========================================================

  # == Class Methods ========================================================

  # == Instance Methods =====================================================

  def process
    conditions = eval(self.export.export_conditions)
    csv = Transaction.financial_transaction_report_columns.
      search(conditions).result.copy_to_string
    export_process(csv)
  end
end