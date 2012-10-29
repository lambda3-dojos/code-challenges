# -*- encoding : utf-8 -*-  
class Fixnum
	def fatorial
		(1..self).to_a.inject(1) { |r, i| r * i}
	end
end

frase = [ "Mussum ipsum cacilds, vidis litro abertis.", "Consetis adipiscings elitis. Etiam ac mauris lectus, non scelerisque augue. Aenean justo massa.", "Pra lá , depois divoltis porris, paradis. Casamentiss faiz malandris se pirulitá, Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum.", "Paisis, filhis, espiritis santis. Lorem ipsum dolor sit amet, consectetuer Ispecialista im mé intende tudis nuam golada, vinho, uiski, carirí, rum da jamaikis, só num pode ser mijis.", "Mé faiz elementum girarzis, nisi eros vermeio, in elementis mé pra quem é amistosis quis leo. Atirei o pau no gatis. Viva Forevis aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.", "Manduma pindureta quium dia nois paga. Adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.", "Sapien in monti palavris qui num significa nadis i pareci latim. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.", "Interessantiss quisso pudia ce receita de bolis, mais bolis eu num gostis. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.", "Suco de cevadiss, é um leite divinis, qui tem lupuliz, matis, aguis e fermentis. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.", "Pellentesque laoreet mé vel lectus scelerisque interdum cursus velit auctor. Lorem ipsum dolor sit amet, consectetur adipiscing elit."]

repetition = 2
size = frase.size.fatorial * repetition
total = 0  
file_name = "big-file-2.txt"

File.delete(file_name) if File.exists?(file_name)
File.open(file_name, "a") do |file|
	repetition.times do |t|	
		frase.permutation.each do |p|
			file.puts p.join(' ')
			if total % 100000 == 0
				percentage = (total.to_f / size) * 100
				puts " => Processing #{ "%.2f" % percentage }%" 
			end
			total += 1
		end
	end
	file.puts "New unique line"
end