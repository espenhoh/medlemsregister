$(document).ready(function(){
	

	$('.dataframe').DataTable({
		paging: false,
		searching: false,
		"aaSorting": [],
		'columns': [
			{ 'orderable': false },
			null,
			null,
			null,
			null,
			{ 'orderable': false },
			{ 'orderable': false },
			{ 'orderable': false },
			null
		  ],
		'language': {
			'info': ''
		}
	});

});