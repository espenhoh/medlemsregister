$(document).ready(function(){
	
	$('#eksporter_til_PDF').click(function(){
            var divContents = $("#container").html();
            var printWindow = window.open('', '', 'height=400,width=800');
            printWindow.document.write('<html><head><title>DIV Contents</title>');
            printWindow.document.write('</head><body >');
            printWindow.document.write(divContents);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();

		
		
		
		/*
		if(('eksporterPDF').length > 0){
			$('h1, h2, thead, tbody tr').not('.eksporterPDF').hide();
		}
		*/
		
		//$('h1, h2, thead, tbody tr').show();
	})
	
	
	$('tbody tr').click(function(){
		var tabell = $(this).closest('table')
		
		
		
		if ( $(this).hasClass('eksporterPDF')) {
			$(this).removeClass('eksporterPDF');
			if (tabell.find('tr.eksporterPDF').length == 0) {
				tabell.find('thead').removeClass('eksporterPDF');
				tabell.prev('h2').removeClass('eksporterPDF');
				tabell.prevAll('h1').removeClass('eksporterPDF');
			}
		} else {
			$(this).addClass('eksporterPDF');
			tabell.find('thead').addClass('eksporterPDF');
			tabell.prev('h2').addClass('eksporterPDF');
			tabell.prevAll('h1').addClass('eksporterPDF');
		}
	}); 

});