from relationalai.experimental.graphs import ego_network

def exec(model, query, readonly=True):
    """Helper to execute raw queries and print the result.

    Args:
        model: The database model instance that provides the exec_raw method.
        query (str): The raw query string to be executed.
        readonly (bool, optional): Whether the query should be executed in read-only mode.

    Graph query example:
        >>> print("Running graph query:")
        >>> exec(model, '''
            def my_edges { (1, 2); (2, 3); (3, 4); (4, 1); }
            def G { ::graphlib::directed_graph[my_edges] }
            from ::graphlib_experimental import ego_network
            def output { ego_network[G, 3, 1] }
        ''')
    """
    print(model.exec_raw(query, readonly=readonly).results)
    print()

def install_egonets_library(model):
    """Installs the egonets package and its dependencies in the database.
    This is necessary (could change in the future) for experimental packages.
    Every time a database is created on which we want to use the package, we need to install it.

    This function performs a series of operations to:
    1. Check currently installed packages
    2. Update the package registry
    3. Install the graphlib_experimental package
    4. Verify the installation

    Args:
        model: The RAI DB model used to execute package management queries.
    """
    print(" Checking currently installed libraries: ")
    exec(model, """ def output { ::std::pkg::project::static_lock } """)

    print(" Checking currently available libraries: ")
    exec(model, """ def output { ::std::pkg::package::name } """)

    print(" Update registry to make sure all libraries in the registry are in the DB's registry. ")
    exec(model, """
        def response { ::std::pkg::registry::update_by_name["RAI"] }
        def insert { response[:insert] }
        def delete { response[:delete] }
    """,
    readonly=False)

    print(" Checking currently available libraries: ")
    exec(model, """ def output { ::std::pkg::package::name } """)

    print(" Install graphlib_experimental: ")
    exec(model, """
        def response { ::std::pkg::project::add_package["graphlib_experimental"] }
        def insert { response[:insert] }
        def delete { response[:delete] }
    """)

    print(" Checking currently installed libraries: ")
    exec(model, """ def output { ::std::pkg::project::static_lock } """)