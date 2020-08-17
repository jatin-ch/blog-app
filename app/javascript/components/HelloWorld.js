import React from "react"
import PropTypes from "prop-types"
class HelloWorld extends React.Component {
  render () {
    return (
      <React.Fragment>
        <h1>Greeting: {this.props.greeting}</h1>
        <p>Name: {this.props.name}, Age: {this.props.age}</p>
      </React.Fragment>
    );
  }
}

HelloWorld.propTypes = {
  greeting: PropTypes.string,
  name: PropTypes.string,
  age: PropTypes.number
};
export default HelloWorld
