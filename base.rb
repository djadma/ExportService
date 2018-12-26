class Exports::Base
  # == Constants ============================================================

  # == Attributes ===========================================================

  attr_accessor :export

  # == Class Methods ========================================================

  # == Instance Methods =====================================================

  def initialize(export)
    self.export = export
  end

  def create(conditions)
    self.export.status = "new"
    self.export.error = nil
    self.export.export_type = self.export_type
    self.export.export_conditions = conditions
    self.export.save!

    ExportWorker.perform_async(self.export.id)
  end

  def export_process(csv)
    self.export.update_column(:status, "processing")

    processed_at = Time.zone.now
    file_name = "#{self.export.export_type.underscore.dasherize}-export-#{processed_at.to_s(:filename)}.csv"
    temp_file = File.new(file_name, "w+", encoding: "ascii-8bit")
    temp_file.write(csv)
    temp_file.flush

    self.export.report = temp_file
    self.export.status = "processed"
    self.export.processed_at = processed_at
    self.export.error = nil
    self.export.save!

    temp_file.close
    File.delete(file_name)
   rescue Exception => e
    self.export.update_columns({
      status: "error",
      error: e.message
    })
  end

  def export_type
    a = self.class.name
    a.slice!("Exports::")
    a
  end
end