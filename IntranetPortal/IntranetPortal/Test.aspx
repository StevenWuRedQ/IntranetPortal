<!-- index.html -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>React Tutorial</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/react/0.14.2/react.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/react/0.14.2/react-dom.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.8.23/browser.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/marked/0.3.2/marked.min.js"></script>
</head>
<body>
    <div id="content"></div>
    <script type="text/babel">

        var data = [
  {id: 1, author: "Pete Hunt", text: "This is one comment"},
  {id: 2, author: "Jordan Walke", text: "This is *another* comment"}
];

        var CommentBox = React.createClass({
          getInitialState: function() {
    return {data: []};
  },

    render: function() {
        return (
          <div className="commentBox">
            Hello, world! I am a CommentBox.
               <CommentList data={this.state.data}/>
                <CommentForm/>
          </div>
      );
    }
});

        var CommentList = React.createClass({
        render: function() {
            var commentNodes = this.props.data.map(function(comment){
                return (
                 <Comment author={comment.author} key={comment.id}>
          {comment.text}
        </Comment>
        );
        })

    return (

      <div className="commentList">
        {commentNodes}
      </div>

    );
  }
});

var CommentForm = React.createClass({
  render: function() {
    return (
      <div className="commentForm">
        Hello, world! I am a CommentForm.
      </div>
    );
  }
});


        var Comment = React.createClass({
  render: function() {
    return (
      <div className="comment">
        <h2 className="commentAuthor">
          {this.props.author}
        </h2>
        {marked(this.props.children.toString(), {sanitize: true})}
      </div>
    );
  }
});

ReactDOM.render(
  <CommentBox data={data}/>,
  document.getElementById('content')
);
        


    </script>
</body>
</html>
