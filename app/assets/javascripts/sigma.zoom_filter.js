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
		max_displayed_nodes: 50
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

	this.add_on_screen_nodes = function() {
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

	this.hide_node = function(node) {	
		node['hidden'] = true;
	}

	this.show_node = function(node) {
		node['hidden'] = false;
	}

	this.sort_nodes_DESC = function(nodes) {
		nodes.sort(function(a, b) {return b['size'] - a['size']});
	}

	this.validate_nodes = function() {
		self.add_on_screen_nodes();

		self.sort_nodes_DESC(self.visible_nodes);
		self.sort_nodes_DESC(self.hidden_nodes);
		
		while ((!self.visible_nodes[0] == null && !self.hidden_nodes[0] == null) && 
				(self.visible_nodes[0]['size'] < self.hidden_nodes[0]['size'])) {
			self.visible_nodes.push(self.hidden_nodes.shift());
			self.sort_nodes_DESC(self.visible_nodes);
		}
		
		if (self.visible_nodes.length > self.p.max_displayed_nodes) {
			self.visible_nodes.splice(self.p.max_displayed_nodes, self.visible_nodes.length).forEach(function(node) {
				self.hidden_nodes.push(node)
			})
		}else{
			diff = self.p.max_displayed_nodes - self.visible_nodes.length;
			
			hidden_nodes_on_screen = 	self.hidden_nodes.filter(function(node) {return self.isOnScreen(node)})

			hidden_nodes_on_screen
			.splice(0, diff)
			.forEach(function(node) {
				self.visible_nodes.push(node);
				self.hidden_nodes.splice(self.hidden_nodes.indexOf(node), 1);
			})
		}
	}

	this.filter = function() {
		self.validate_nodes();

		self.hidden_nodes.forEach(function(node) {
			self.hide_node(node)
		});

		self.visible_nodes.forEach(function(node) {
			self.show_node(node)
		});
	}

	this.delete = function() {
		self.hidden_nodes.forEach(function(node) {
			self.show_node(node)
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
}

sigma.publicPrototype.start_filtering = function() {
	this.zoom_filter = new sigma.zoom_filter.zoom_filter(this);
	this.zoom_filter.start_filtering();
}

sigma.publicPrototype.stop_filtering = function() {
	this.zoom_filter.stop_filtering();
}
