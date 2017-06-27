$(document).on('turbolinks:load', function() {
    $('#run-table').DataTable({
        "order": [[ 2, "desc" ]],
        autoWidth: false,
        pagingType: 'full_numbers'

    });

    $('#time-picker').datetimepicker({
        format: 'HH:mm:ss',
        sideBySide: true,
    });

    $('#datetime-picker').datetimepicker({
        format: 'DD/MM/YYYY HH:mm',
        sideBySide: true,
    });
});
