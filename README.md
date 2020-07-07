# AutoMart-API
## Introduction
An online marketplace for automobiles of diverse makes, model or body type. With AutoMart, users can sell their cars or buy from trusted dealerships or private sellers.

## Table of Contents
1. <a href="#hosted-app">Link to Hosted App</a>
2. <a href="#stack-used">Tech Stack Used</a>
3. <a href="#application-features">Application Features</a>
4. <a href="#how-to-use">How To Use</a>
5. <a href="#contributing">Contributing</a>
6. <a href="#author">Author</a>
7. <a href="#license">License</a>


## Link to Hosted App
* [API link](#)

## Tech Stack Used

- [Ruby](https://rubygems.org/) | Version: 2.6.0
- [Rails](https://rubyonrails.org/) | Version: 6.0.1
- [Postgresql](https://www.postgresql.org/)

## Application Features

* Register a user
* User login
* User (Seller) can post a car sale Advertisement
* Users can view a list of all unsold cars
* User can view all unsold cars of a specific body type
* User can view the details of a specific car
* User (Seller) can update the details and status of his/her car AD
* User (Seller) can delete his/her car AD
* User (Buyer) can make a purchase order
* User (Buyer) can update the price of his/her order
* User (Seller) can update the status of a Buyer’s order to accepted or rejected
* User (Buyer) can view the details of a specific order
* User (Buyer) can delete a specific order
* User (Buyer) can view all of his/her purchase orders
* User can flag/report a posted AD as fraudulent
* User can view details of a flag report
* User can update details of a flag report
* User can delete a flag report
* Admins can view all car ADs whether sold or unsold
* Admin can delete a posted car AD record and order

## How To Use

To clone and run this application, you'll need [Git](https://git-scm.com), [Ruby](https://rubygems.org/) and [Rails](https://rubyonrails.org/) installed on your computer. From your command line:

```bash
# Clone this repository
$ git clone https://github.com/teepha/automart-API.git

# Go into the repository
$ cd automart-API

# Install dependencies
$ bundle install

# Create .env file for environmental variables in your root directory like the sample.env file and provide the keys

# Create the db
$ rails db:create

# Run migration
$ rails db:migrate

# Start the app
$ rails s

# Check the port on the specified port on the env or 3000

# Run test
$ rails test
```

## API endpoints

Base_URL -> ```localhost:3000```
  * Register: 
  ```
  {
    path: '/signup',
    method: POST,
    body: {
      first_name: <string>,
      last_name: <string>,
      email: <string, unique>,
      password: <string>,
    }
  }
  ```
 * Login: 
  ```
  {
    path: '/auth/login',
    method: POST,
    body: {
      email: <string, unique>,
      password: <string>
    }
  }
  ```
  * Users can view a list of all unsold cars: 
  ```
  {
    path: '/cars',
    method: GET,
    header: Authorization<token>
  }
  ```
  * User can view all unsold cars of a specific body-type: 
  ```
  {
    path: '/cars/body_type',
    method: GET,
    header: Authorization<token>,
    params: {
      query_params: <string>,
    }
  }
  ```
  * Admin can view all car ADs whether sold or unsold: 
  ```
  {
    path: '/all_cars',
    method: GET,
    header: Authorization<token: admin>
  }
  ```
  * User (Seller) can post a car sale Advertisement: 
  ```
  {
    path: '/cars',
    method: POST,
    header: Authorization<token>,
    body: {
      state: <string>,
      price: <integer>,
      model: <string>,
      manufacturer: <string>,
      body_type: <'car' or 'truck' or 'trailer' or 'van' or 'bus' or 'minibus'>
    }
  }
  ```
  * User can view the details of a specific car: 
  ```
  {
    path: '/cars/<id>',
    method: GET,
    header: Authorization<token>,
    params: {
      id: <integer>,
    }
  }
  ```
  * User (Seller) can update the details and status of his/her car AD: 
  ```
  {
    path: '/cars/<id>',
    method: PUT,
    header: Authorization<token>,
    params: {
      id: <integer>,
    },
    body: {
      state: <string>,
      price: <integer>,
      model: <string>,
      manufacturer: <string>,
      body_type: <string: 'car' or 'truck' or 'trailer' or 'van' or 'bus' or 'minibus'>,
      status: <string: 'available' or 'sold'>
    }
  }
  ```
  * User (Seller) can delete his/her car AD: 
  ```
  {
    path: '/cars/<id>',
    method: DELETE,
    header: Authorization<token>,
    params: {
      id: <integer>,
    }
  }
  ```
  * Admin can delete a specific car AD: 
  ```
  {
    path: '/cars/<id>',
    method: DELETE,
    header: Authorization<token: admin>,
    params: {
      id: <integer>
    }
  }
  ```
  * User (Buyer) can make a purchase order: 
  ```
  {
    path: '/cars/<car_id>/orders',
    method: POST,
    header: Authorization<token>,
    params: {
      car_id: <integer>
    }
    body: {
      "amount":  <integer>
    }
  }
  ```
  * User (Buyer) can update the price of his/her order: 
  ```
  {
    path: '/cars/<car_id>/orders/<id>',
    method: PUT,
    header: Authorization<token>,
    params: {
      car_id: <integer>,
      id: <integer>
    },
    body: {
      "amount":  <integer>
    }
  }
  ```
  * User (Seller) can update the status of a Buyer’s order to accepted or rejected: 
  ```
  {
    path: '/cars/<car_id>/orders/<id>/status',
    method: PUT,
    header: Authorization<token>,
    params: {
      car_id: <integer>,
      id: <integer>
    },
    body: {
      "status":  <string: 'accepted' or 'rejected'>
    }
  }
  ```
  * User (Buyer) can view the details a specific order: 
  ```
  {
    path: '/cars/<car_id>/orders/<id>',
    method: GET,
    header: Authorization<token>,
    params: {
      car_id: <integer>,
      id: <integer>
    }
  }
  ```
  * User (Buyer) can delete a specific order: 
  ```
  {
    path: '/cars/<car_id>/orders/<id>',
    method: DELETE,
    header: Authorization<token>,
    params: {
      car_id: <integer>,
      id: <integer>
    }
  }
  ```
  * User (Buyer) can view all of his/her purchase orders:
  ```
  {
    path: '/cars/<car_id>/orders',
    method: GET,
    header: Authorization<token>
  }
  ```
  * Admin can delete a specific order: 
  ```
  {
    path: '/cars/<car_id>/orders/<id>',
    method: DELETE,
    header: Authorization<token: admin>,
    params: {
      car_id: <integer>,
      id: <integer>
    }
  }
  ```
  * User can flag/report a posted AD as fraudulent:
  ```
  {
    path: '/cars/<car_id>/flags',
    header: Authorization<token>,
    method: POST,
    params: {
      car_id: <integer>
    },
    body: {
      reason: <string>,
      description: <string>
    }
  }
  ```
  * User can view details of a flag report:
  ```
  {
    path: '/cars/<car_id>/flags/<id>',
    header: Authorization<token>,
    method: GET,
    params: {
      car_id: <integer>,
      id: <integer>
    }
  }
  ```
  * User can update details of a flag report:
  ```
  {
    path: '/cars/<car_id>/flags/<id>',
    header: Authorization<token>,
    method: PUT,
    params: {
      car_id: <integer>,
      id: <integer>
    },
    body: {
      reason: <string>,
      description: <string>
    }
  }
  ```
  * User can delete a flag report:
  ```
  {
    path: '/cars/<car_id>/flags/<id>',
    header: Authorization<token>,
    method: DELETE,
    params: {
      car_id: <integer>,
      id: <integer>
    }
  }
  ```
  * Admin can view a list of all flag reports:
  ```
  {
    path: '/cars/<car_id>/flags',
    header: Authorization<token: admin>,
    method: GET,
    params: {
      car_id: <integer>
    }
  }
  ```

## Contributing
* Fork it: [Fork the Automart-API project](https://github.com/teepha/automart-API/fork)
* Create your feature branch (`git checkout -b my-new-feature`)
* Commit your changes (`git commit -am 'Add some feature'`)
* Push to the branch (`git push origin my-new-feature`)
* Create a new Pull Request

## Author

Lateefat Amuda

## License

MIT

---