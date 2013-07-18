jQuery ->
 $('#package_subject_ids').chosen()
 $('#package_access_id').chosen()
 $('#package_format_id').chosen()
 $('#package_language_id').chosen()
 $('#package_retention_id').chosen()
 $('#package_type_id').chosen()
 $('input.date_picker').datepicker
   dateFormat: "yy-mm-dd"
   changeYear: true
   yearRange: "c-100:c+10"
