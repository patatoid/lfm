sigma.zoom_filter = sigma.zoom_filter || {};

//tool to clone functions in order to override draw method
Function.prototype.clone = function() {
	var self =this;
	var temp = function temporary() { return self.apply(this, arguments); };
	for (key in this) {
		temp[key] = this[key];
	}
	return temp;
};

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
		return (node['displayX'] + node['displaySize'] < sigInst._core.width) &&
			(node['displayX'] - node['displaySize'] > 0) &&
			(node['displayY'] + node['displaySize'] < sigInst._core.height) &&
			(node['displayY'] - node['displaySize'] > 0)
	}

	this.check_nodes = function() {
		var i;
		sigInst._core.graph.nodes.forEach(function(node) {
			if (self.isOnScreen(node) && !node['hidden']){
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

	this.display_hidden_offScreen_visible_nodes = function() {
		document.getElementById('inScreen').innerHTML = "";
		document.getElementById('outScreen').innerHTML = "";
		document.getElementById('hidden').innerHTML = "";
		self.visible_nodes.forEach(function(node) {document.getElementById('inScreen').innerHTML += node['size'] + " - "});
		self.offScreen_nodes.forEach(function(node) {document.getElementById('outScreen').innerHTML += node['size'] + " - "});
		self.hidden_nodes.forEach(function(node) {document.getElementById('hidden').innerHTML += node['size'] + " - "});
	}

	this.filter = function() {
		self.check_nodes();

		self.visible_nodes.sort(function(a, b) {return b['size'] - a['size']});
		self.hidden_nodes.sort(function(a, b) {return b['size'] - a['size']});
		
		while ((!self.visible_nodes[0] == null && !self.hidden_nodes[0] == null) && 
				(self.visible_nodes[0]['size'] < self.hidden_nodes[0]['size'])) {
			self.visible_nodes.push(self.hidden_nodes.shift());
			self.visible_nodes.sort(function(a, b) {return b['size'] - a['size']});
		}
		
		if (self.visible_nodes.length > self.p.max_displayed_nodes) {
			self.visible_nodes.splice(self.p.max_displayed_nodes, self.visible_nodes.length).forEach(function(node) {
				self.hidden_nodes.push(node)
			})
		}else{
			diff = self.p.max_displayed_nodes - self.visible_nodes.length;
			
			hidden_nodes_on_screen = 	self.hidden_nodes.filter(function(node) {return self.isOnScreen(node)})

			hidden_nodes_on_screen
			.splice(0, hidden_nodes_on_screen.length < diff ? hidden_nodes_on_screen.length : diff)
			.forEach(function(node) {
				self.visible_nodes.push(node);
				self.hidden_nodes.splice(self.hidden_nodes.indexOf(node), 1);
			})
		}

		self.hidden_nodes.forEach(function(node) {
			//i = sigInst._core.graph.nodes.indexOf(node);
			//if (i) {sigInst._core.graph.nodes.splice(i, 1)}
			node['hidden'] = true;
		});

		self.visible_nodes.forEach(function(node) {
			//i = sigInst._core.graph.nodes.indexOf(node);
			//if (i) {sigInst._core.graph.nodes.push(node)}
			node['hidden'] = false;
		});

//		self.display_hidden_offScreen_visible_nodes();
	}

	this.delete = function() {
		self.hidden_nodes.forEach(function(node) {
			//sigInst._core.graph.nodes.push(node)
			node['hidden'] = false;
		});

		self.hidden_nodes = [];
	}

	this.temp_draw = sigInst._core.draw.clone();

	this.stop_filtering = function() {
		self.delete();
		sigInst._core.draw = function(a,b,c,d) {
			return self.temp_draw(a,b,c,d);	
		}
		sigInst.draw();
	}

	this.start_filtering = function() {
		sigInst._core.draw = function(a,b,c,d) {
			self.filter();
			return self.temp_draw(a,b,c,d);	
		}
		sigInst.draw();
	}

//	sigInst._core.domRoot.addEventListener('mousewheel', function(e) {self.filter()}, false);
	document.getElementById('button').addEventListener('click', function() {
		if (document.getElementById('button').innerHTML == 'filter') {
			self.start_filtering();
			document.getElementById('button').innerHTML = 'unfilter';
		}else{
			self.stop_filtering();
			document.getElementById('button').innerHTML = 'filter';
		}
	}, true);

}

sigma.publicPrototype.zoom_filter = function() {
	sigma.zoom_filter.zoom_filter(this);
}

