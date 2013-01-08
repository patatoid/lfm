sigma.zoom_filter = sigma.zoom_filter || {};

sigma.zoom_filter.zoom_filter = function(sigInst) {
	sigma.classes.Cascade.call(this);
	
	var self = this;

	this.p = {
		max_displayed_nodes: 20
	};

	this.visible_nodes = [];
	this.offScreen_nodes = [];
	this.hidden_nodes = [];

	this.isOnScreen = function(node){
		return (node['displayX'] < sigInst._core.width) &&
			(node['displayX'] > 0) &&
			(node['displayY'] < sigInst._core.height) &&
			(node['displayY'] > 0)
	}

	this.check_nodes = function() {
		var i;
		sigInst._core.graph.nodes.forEach(function(node) {
			if (self.isOnScreen(node)){
				if (self.visible_nodes.indexOf(node) < 0) {self.visible_nodes.push(node)};
				i = self.offScreen_nodes.indexOf(node);
				if (i >= 0) {self.offScreen_nodes.splice(i, 1)};
			}else{
				if (self.offScreen_nodes.indexOf(node) < 0) {self.offScreen_nodes.push(node)};
				i = self.visible_nodes.indexOf(node);
				if (i >= 0) {self.visible_nodes.splice(i,1)};
			}
		})
	}

	this.display_offScreen_visible_nodes = function() {
		document.getElementById('inScreen').innerHTML = "";
		document.getElementById('outScreen').innerHTML = "";
		document.getElementById('hidden').innerHTML = "";
		self.visible_nodes.forEach(function(node) {document.getElementById('inScreen').innerHTML += node['label'] + " - "});
		self.offScreen_nodes.forEach(function(node) {document.getElementById('outScreen').innerHTML += node['label'] + " - "});
		self.hidden_nodes.forEach(function(node) {document.getElementById('hidden').innerHTML += node['label'] + " - "});
	}

	this.filter = function() {
		self.check_nodes();

		if (self.visible_nodes.length > self.p.max_displayed_nodes){
			self.visible_nodes.sort(function(a, b) {return a['weight'] - b['weight']});
			self.visible_nodes.splice(self.p.max_displayed_nodes, self.visible_nodes.length).forEach(function(node) {
				self.hidden_nodes.push(node)
			})
		}else{
			self.hidden_nodes.sort(function(a, b) {return b['weight'] - a['weight']});
			diff = self.p.max_displayed_nodes - self.visible_nodes.length
			self.hidden_nodes.splice(0, self.hidden_nodes.length < diff ? self.hidden_nodes.length : diff).forEach(function(node) {
				self.visible_nodes.push(node);
			})
		}

		self.hidden_nodes.forEach(function(node) {
			i = sigInst._core.graph.nodes.indexOf(node);
			if (i) {sigInst._core.graph.nodes.splice(i, 1)}
		});

		self.visible_nodes.forEach(function(node) {
			i = sigInst._core.graph.nodes.indexOf(node);
			if (i) {sigInst._core.graph.nodes.push(node)}
		});

		self.display_offScreen_visible_nodes();
		sigInst.draw();
	}

	this.delete = function() {
		self.hidden_nodes.forEach(function(node) {
			sigInst._core.graph.nodes.push(node)
		});
		sigInst.draw();
		self.hidden_nodes = [];
		}
//	sigInst._core.domRoot.addEventListener('mousewheel', function(e) {self.filter()}, false);
	document.getElementById('button').addEventListener('click', function() {
		if (document.getElementById('button').innerHTML == 'filter') {
			self.filter();
			document.getElementById('button').innerHTML = 'unfilter';
		}else{
			self.delete();
			document.getElementById('button').innerHTML = 'filter';
		}
	}, true);

}

sigma.publicPrototype.zoom_filter = function() {
	sigma.zoom_filter.zoom_filter(this);
}

