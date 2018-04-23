$(document).ready(function(){
	

	$('.dataframe').DataTable({
		paging: false,
		searching: false,
		'columns': [
			null,
			null,
			null,
			null,
			null,
			{ 'orderable': false },
			{ 'orderable': false },
			{ 'orderable': false },
			{ 'orderable': false }
		  ],
		'language': {
			'info': ''
		}
	});

});