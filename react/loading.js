import React from 'react';
import CircularProgress from 'material-ui/lib/circular-progress';

module.exports = React.createClass({
  render: function() {
    return <div className="loading"><CircularProgress mode="indeterminate" size={2} /></div>;
  }
});
