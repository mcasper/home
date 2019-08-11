import React from 'react';

class Navbar extends React.Component {
  render() {
    return(
      <nav className='navbar navbar-dark bg-dark' style={{height: '70px', color: 'white'}}>
        <div>
          <a href='/budget' style={{textDecoration: 'none', color: 'white'}}>Budget</a>
          <a href='/budget' style={{textDecoration: 'none', color: 'white'}}>   |   </a>
          <a href='/' style={{textDecoration: 'none', color: 'white'}}>Back to Home</a>
        </div>

        <div>
          <a href='/auth/signout' style={{textDecoration: 'none', color: 'white'}}>Sign Out</a>
        </div>
      </nav>
    )
  }
}

export default Navbar;
