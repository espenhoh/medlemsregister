$(document).ready(function(){

	$('.data_table').DataTable();
	
	function genererPDF(tittel, undertittel, ids) {
		var dokument = new jsPDF('l', 'pt');
		
		
		//Overskrift
		dokument.setFontSize(30)
		dokument.text(tittel, 40, 40);
		
		var tabellnr, Ystart;
		for (tabellnr = 0; tabellnr < ids.length; tabellnr++) {
			
			var res = dokument.autoTableHtmlToJson(document.getElementById('tabell' + tabellnr));
			
			if (tabellnr > 0 ) {
				Ystart = dokument.autoTable.previous.finalY + 40;
			} else {
				Ystart = 80;
			}
				
			var header = function(data) {
				dokument.setFontSize(20);
				dokument.setTextColor(44);
				dokument.setFontStyle('normal');
				dokument.text(undertittel[tabellnr], data.settings.margin.left, Ystart);
			};
			
			var options = {
				addPageContent: header,
				startY: Ystart + 20,
				margin: {
				  top: 80
				}
			};
			dokument.autoTable(res.columns, res.data, options);
		} 
				
		dokument.save(tittel + '.pdf');
	}
	
	$('#eksporter_til_PDF').click(function(){
       	if($('.eksporterPDF').length > 0) {
			//Slett alt som ikke skal printes til PDF
			$('h1, h2, thead, tbody tr').not('.eksporterPDF').remove();
			var ids = [];
			var tittel = $('h1').text();
			var undertittel = [];
			$('table').each(function(index){
				// Autotable støtter kun id så vi fester en id til hver tabell
				$(this).attr('id', 'tabell'+index);
				ids.push('tabell'+index)
				undertittel.push($(this).prev('h2').text());
			});
			
			
			genererPDF(tittel, undertittel, ids);
			
			//Kjør et nytt kall mot server for å få tilbake alle radene
			location.reload(true);
		}
		
		
		//$('h1, h2, thead, tbody tr').show();
	});
	
	
	$('tbody tr').click(function(){
		var tabell = $(this).closest('table')
		
		
		
		if ( $(this).hasClass('eksporterPDF')) {
			$(this).removeClass('eksporterPDF');
			if (tabell.find('tr.eksporterPDF').length == 0) {
				tabell.find('thead').removeClass('eksporterPDF');
				tabell.prev('h2').removeClass('eksporterPDF');
				$('h1').removeClass('eksporterPDF');
			}
		} else {
			$(this).addClass('eksporterPDF');
			tabell.find('thead').addClass('eksporterPDF');
			tabell.prev('h2').addClass('eksporterPDF');
			$('h1').addClass('eksporterPDF');
		}
	}); 

});