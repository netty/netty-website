This is an web site project based on [Awestruct](http://awestruct.org/).  It generates the complete web site and documentation of the [Netty project](http://netty.io/).  

To contribute to the project documentation, simply fork this repository and issue a pull request.


### Step 1. Installing Awestruct

Your system must have a working Ruby installation (1.9+) because Awestruct is written in Ruby.  You can install Awestruct using the `bundle` command:

    $ bundle install


### Step 2. Fork netty-website Repository

First, fork the [official repository](https://github.com/netty/netty-website) and clone it into your local storage:

    $ git clone git@github.com:<username>/netty-website.git
    
Switch to your newly cloned repository and add netty-website as a remote
    
    cd netty-website/
    git remote add upstream git://github.com/netty/netty-website
    
Optionally, you may wish to create a branch if you are planning multiple contributions. Please choose the branch name wisely because everyone will see it.
    
    $ git fetch upstream
    $ git checkout -b <branchName> upstream/master


### Step 3. Making Changes and Testing

Modify the web site files as you wish.

To test locally, start the embedded web server using Awestruct.

    $ cd netty-website
    $ bundle exec awestruct --auto --server -u https://netty.io

The web site will be available at `http://localhost:4242/`

When the embedded Awestruct web server is running, changes you make will trigger a re-generation of the web site. Wait for this to complete before refreshing your browser to see your changes.


### Step 4. Committing your changes

To commit all your changes:

    $ git commit -a

Next, push your changes back to your fork on github. You only need to supply a branch name if you previously created a branch.

    $ git push origin <branchName>

Lastly, submit a pull request from your repository. Make sure to make the pull request using the branch you used for the guide.


### Step 5. Deploying the web site

Only those with commit access will be able to perform this step.

Run the `_bin/deploy.sh` script with the path to [the Github Pages repository](https://github.com/netty/netty.github.com/):

    $ cd netty-website
    $ _bin/deploy.sh ../netty.github.com

The example above copies the generated web site into the local Github Pages repository located at `../netty.github.com`, and pushes all the changes to origin.

