import React from 'react';

class CityDetail extends React.Component {
  render() {
    return (
      <div>
        <hr />
        <h1>City Details</h1>
        <table width={"100%"}>
          <tr>
            <th>
              Zip Code
            </th>
            <th>
              Latitude
            </th>
            <th>
              Longitude
            </th>
            <th>
              City
            </th>
            <th>
              State
            </th>
            <th>
              County
            </th>
          </tr>
          {this.props.results.map(function (result) {
            return (<tr>
              <td>
                {result.zipcode}
              </td>
              <td>
                {result.latitude}
              </td>
              <td>
                {result.longitude}
              </td>
              <td>
                {result.city}
              </td>
              <td>
                {result.state}
              </td>
            </tr>);
          })}
        </table>
      </div>
    );
  }
}

export default CityDetail;